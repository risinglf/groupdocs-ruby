require 'spec_helper'

describe GroupDocs::Storage::Package do

  it_behaves_like 'Api entity'

  context 'attributes' do
    it { should respond_to(:name)     }
    it { should respond_to(:name=)    }
    it { should respond_to(:objects)  }
    it { should respond_to(:objects=) }
  end

  context 'instance methods' do
    describe '#<<' do
      it 'adds objects to be packed later' do
        subject.objects = ['object 1']
        subject.objects.should_receive(:<<).with('object 2')
        subject << 'object 2'
      end
    end

    describe '#create!' do
      it 'returns URL for package downloading' do
        mock_api_server(load_json('package_create'))
        subject.objects = [stub(name: 'object 1')]
        subject.create!.should be_a(String)
      end
    end
  end
end
