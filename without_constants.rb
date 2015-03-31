require 'allocation_tracer'


class WithFreeze
  def run
    1000.times do
      "This is a string".gsub("a string", ''.freeze)
    end
  end
end

ObjectSpace::AllocationTracer.setup(%i{path line type})
object_without_freeze = WithFreeze.new

r = ObjectSpace::AllocationTracer.trace do
  1000.times { object_without_freeze.run }
end

r.sort_by { |k,v| v.first }.each do |k,v|
  p k => v
end

p string_alloc: ObjectSpace::AllocationTracer.allocated_count_table[:T_STRING]
p :TOTAL => ObjectSpace::AllocationTracer.allocated_count_table.values.inject(:+)

__END__


{["without_constants.rb", 7, :T_REGEXP]=>[1, 1, 336, 336, 336, 0]}
{["without_constants.rb", 7, :T_NODE]=>[1000, 0, 1334, 1, 2, 0]}
{["without_constants.rb", 7, :T_MATCH]=>[1001000, 0, 1001200, 0, 3, 239552400]}
{["without_constants.rb", 7, :T_STRING]=>[6000004, 1409, 6234688, 0, 336, 128578557]}
{:string_alloc=>6000004}
{:TOTAL=>7002005}
