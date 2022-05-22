LC = LocalCongruence

"""
	cellCongruenceSMWithTasks(
		cop::Lar.ChainOp,
		lo_cls::Array{Array{Int,1},1},
		lo_sign::Array{Array{Int8,1},1};
		imp = false,
		d = 0
	)::Tuple{ Lar.ChainOp,  Array{Array{Int,1},1},  Array{Array{Int8,1},1} }

Evaluates the Cell Congruence for a Cochain `cop with classes `lo_cls.

The function determines the new Cochain Operator built from `cop` where
the lower order cells are merged according to `lo_cls` map.
`lo_sign` specifies whether a cell must be considered in reverse order.

If optional paramenter `imp` is set to `true` then FP imprecisions
are taken into account in the sense that lower order cells may have collided.
The parameter `d` represent then the order of the cell (that also is the
least number of lower order cells a current order cell is made of).

The method returns:
 - the new Cochain Operator
 - a map that, for every new cell, identifies the old cells it is made of
 - a map that, for every new cell, specify if old cells have changed ordering.
"""
function cellCongruenceSMWithTasks(cop, lo_cls, lo_sign; imp = false, d = 0)

	# Collide columns
	copCols = []
	@sync for i = 1 : length(lo_cls)
		@async begin 
            col = sum([
			cop[:, lo_cls[i][j]] .* lo_sign[i][j]
                for j = 1 : length(lo_cls[i])
            ])
#		if imp
#			#TODO remove zeros
#			if length(col.nzind) > d  push!(copCols, col)  end
#		end
            push!(copCols, col)
        end
	end

	# Retrieve Matrix Form and extract rows
	cop = hcat(copCols...)
	rows = [cop[row, :] for row = 1 : cop.m]

	# Adjusting signs such that the first value always is `-1`
	sign = ones(Int8, cop.m)
	@sync for row = 1 : cop.m  
		@async if rows[row].nzval[1] > 0
			rows[row] = -rows[row]
			sign[row] = -1
		end  
	end

	# Sort rows in order to collide them quickly
	rows_ord = @async sortperm(rows)
	nrows = unique(rows[rows_ord])
	ho_cls = [Array{Int,1}() for i = 1 : length(nrows)]
	nidx = 1

	# Collide cells with same structure
	@async for cidx = 1 : cop.m
		if rows[rows_ord[cidx]] != nrows[nidx]  nidx = nidx + 1;  end
		push!(ho_cls[nidx], rows_ord[cidx])
	end

	# Reshaping Sign and Cochain
	ho_sign = [[sign[el] for el in cell] for cell in ho_cls]
#	cop = convert(Lar.ChainOp, hcat(nrows...)')

	return hcat(nrows...)', ho_cls, ho_sign
end

function sumColAndPush(cop, lo_cls, lo_sign, copCols, i)
	col = sum([
			cop[:, lo_cls[i][j]] .* lo_sign[i][j]
			for j = 1 : length(lo_cls[i])
		])
#		if imp
#			#TODO remove zeros
#			if length(col.nzind) > d  push!(copCols, col)  end
#		end
	push!(copCols, col)
end

"""
	chainCongruenceSMWithTasks(
		G::Lar.Points, T::Array{Lar.ChainOp};
		imp=false, ϵ=1e-6
	)::Tuple{Lar.Points, Array{Lar.ChainOp}}

Perform the Geometry `G` congruence and coherently reshape the Topology `T` but with tasks
"""
function chainCongruenceSMWithTasks(G, T; imp=false, ϵ=1e-6)

	# Perform the Geometry Congruence
	G, cls = LC.vertCongruence(G; ϵ=ϵ)
	# Build default sign
	sign = [ones(Int8, length(cl)) for cl in cls]
	# Update the Topology coherently
	Tn = Array{Lar.ChainOp, 1}(undef, length(T))
	for d = 1 : length(T)
		Tn[d], cls, sign = cellCongruenceSMWithTasks(T[d], cls, sign; imp=imp, d=d)
	end
	# Euler Characteristic
	# @show size(G,2) - size(T[1],1) + size(T[2],1)
	return G, Tn
end
