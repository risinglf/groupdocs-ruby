shared_examples_for GroupDocs::Signature::EntityMethods do
  describe '#create!' do
    before(:each) do
      mock_api_server(load_json("#{subject.send(:class_name)}_get"))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.create!(templateId: 'aodfh43yr9834hf943h')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!
    end

    it 'updates identifier of entity' do
      lambda do
        subject.create!
      end.should change(subject, :id)
    end
  end

  describe '#modify!' do
    before(:each) do
      mock_api_server(load_json("#{subject.send(:class_name)}_get"))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.modify!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.modify!
    end
  end

  describe '#rename!' do
    before(:each) do
      mock_api_server(%({ "status": "Ok", "result": { "#{subject.send(:class_name)}_get": null }}))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.rename!('Name', client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'updates name of template' do
      lambda do
        subject.rename!('Name')
      end.should change(subject, :name)
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server(%({ "status": "Ok", "result": { "#{subject.send(:class_name)}_get": null }}))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
