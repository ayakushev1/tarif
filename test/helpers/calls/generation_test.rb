require 'test_helper'

describe Calls::Generation do
  it 'must exists' do
    Calls::Generation.name.must_be :==, 'Calls::Generation'
  end
  
  describe 'class Generator' do
    before do
#      @g = Calls::CallsGeneration.new(self)
    end
    
    it 'must exists' do
      Calls::Generation::Generator.name.must_be :==, 'Calls::Generation::Generator'
    end
    
    describe 'initialize method' do
      it 'must set default calls generation params if input params are empty' do
#        @g = Calls::Generation::Generator.new(self)
#        @g.calls_params.wont_be_nil
#        @g.calls_params.must_be :==, @g.set_initial_inputs(@g.default_calls_generation_params)
      end

      it 'must set generation params from input params' do
#        @g = Calls::Generation::Generator.new(self)
#        calls_params = @g.default_calls_generation_params
#        calls_params['country_id'] = 1111111

#        @g = Calls::Generation::Generator.new(self, calls_params)
#        @g.calls_params['country_id'].must_be :!=, @g.default_calls_generation_params['own_phone']['country_id']
#        @g.calls_params['own_country_id'].must_be :!=, @g.default_calls_generation_params['own_country_id']
#        @g.calls_params.must_be :==, @g.calls_params
      end
      
    end
    
    describe 'helper methods' do
      describe 'random method' do
        it 'must work' do
          Calls::Generation::Generator.new(self).must_respond_to(:random)
        end
      end
    end
  end
  
end

