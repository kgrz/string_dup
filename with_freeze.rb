require 'allocation_tracer'


class WithFreeze
  IM_A_CONSTANT = "a string".freeze
  ANOTHER_CONSTANT = "This is a string"


  def run
    1000.times do
      ANOTHER_CONSTANT.gsub(IM_A_CONSTANT, ''.freeze)
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


