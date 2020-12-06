require 'rails_helper'

RSpec.describe AddSearchTerm do
  describe '#call' do
    context 'when search term is blank' do
      it 'returns nil' do
        res = described_class.new(term: nil).call
        expect(res).to be_nil
      end
    end

    context 'when search term is new for the current block time' do
      it 'creates a SearchTerm and increments count' do
        described_class.new(term: 'steak').call

        st = SearchTerm.last

        aggregate_failures 'SearchTerm attributes' do
          expect(st.block_time).to be_present
          expect(st.term).to eq('steak')
          expect(st.search_count).to eq(1)
        end
      end
    end

    context 'when search term already exists for the current block time' do
      before do
        @term = 'steak'
        @current_time = DateTime.new(2020,12,1,6,14) # 12/1/2020 6:14am
        @block_time =   DateTime.new(2020,12,1,6,0) # 12/1/2020 6:00am

        SearchTerm.create(block_time: @block_time, term: @term, search_count: 100)

        allow(Time).to receive(:now).and_return(@current_time)
      end

      it 'increments count of existing SearchTerm' do
        expect {
          described_class.new(term: @term).call
        }.not_to change(SearchTerm, :count)

        st = SearchTerm.last

        aggregate_failures 'SearchTerm attributes' do
          expect(st.block_time).to eq(@block_time)
          expect(st.term).to eq(@term)
          expect(st.search_count).to eq(101)
        end
      end
    end
  end
end
