include("LinkedQueue.jl")
using .LinkedQueue
module DeTai
using ..LinkedQueue
for sym in names(LinkedQueue; all=false)
    @eval export $sym
    @eval const $sym = LinkedQueue.$sym
end
end # module DeTai