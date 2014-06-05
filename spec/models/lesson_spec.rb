require 'spec_helper'

describe Lesson do
  it { should respond_to(:name) }
  it { should respond_to(:description) }
end
