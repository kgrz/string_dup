require 'allocation_tracer'


class WithoutFreeze
  IM_A_CONSTANT = "a string"
  ANOTHER_CONSTANT = "This is a string"


  def run
    1000.times do
      ANOTHER_CONSTANT.gsub(IM_A_CONSTANT, ''.freeze)
    end
  end
end

ObjectSpace::AllocationTracer.setup(%i{path line type})
object_without_freeze = WithoutFreeze.new

r = ObjectSpace::AllocationTracer.trace do
  1000.times { object_without_freeze.run }
end

r.sort_by { |k,v| v.first }.each do |k,v|
  p k => v
end

p string_alloc: ObjectSpace::AllocationTracer.allocated_count_table[:T_STRING]
p :TOTAL => ObjectSpace::AllocationTracer.allocated_count_table.values.inject(:+)


__END__

{["without_freeze.rb", 11, :T_REGEXP]=>[1, 1, 235, 235, 235, 0]}
{["without_freeze.rb", 11, :T_NODE]=>[1000, 0, 1233, 0, 2, 0]}
{["without_freeze.rb", 11, :T_MATCH]=>[1001000, 0, 999921, 0, 3, 239237520]}
{["without_freeze.rb", 11, :T_STRING]=>[3999913, 554, 4058562, 0, 235, 128417952]}
{:string_alloc=>4000004}
{:TOTAL=>5002005}
