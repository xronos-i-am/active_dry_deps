# frozen_string_literal: true

RSpec.describe ActiveDryDeps do
  it 'all dependencies works' do
    expect(CreateOrder.call).to eq %w[CreateDeparture CreateDeparture job-performed message-ok email-sent-hello]
  end

  it 'stub dependencies with `deps`' do
    service = CreateOrder.new

    expect(service).to deps(
      CreateDepartureCallable: '1',
      CreateDeparture:         double(call: '2'),
      ReserveJob:              '3',
      message:                 '4',
      mailer:                  double(call: '5'),
    )
    expect(service.call).to eq %w[1 2 3 4 5]
  end

  it 'stub dependency with `deps` not runnable' do
    service = CreateOrder.new

    expect(service).not_to deps(:message)
    service.call(is_message: false)
  end

  it 'invalid method identifier not allowed' do
    expect {
      Class.new { include Deps['CreateOrder.!invalid_identifier'] }
    }.to raise_error(ActiveDryDeps::DependencyNameInvalid, 'name +!invalid_identifier+ is not a valid Ruby identifier')
  end

  describe '#stub' do
    def expect_call_orig
      expect(CreateOrder.call).to eq %w[CreateDeparture CreateDeparture job-performed message-ok email-sent-hello]
    end

    it 'stubs dependency with container' do
      stub('CreateDeparture') { double(call: '1') }
      stub('SupplierSync::ReserveJob') { double(perform_later: '2') }

      expect(CreateOrder.call).to eq %w[1 1 2 message-ok email-sent-hello]

      unstub

      expect_call_orig
    end

    it 'stubs dependency with allow' do
      allow(Deps::CONTAINER).to receive(:resolve).with('CreateDeparture').and_return(double(call: '1'))
      allow(Deps::CONTAINER).to receive(:resolve).with('SupplierSync::ReserveJob').and_return(double(perform_later: '2'))

      expect(CreateOrder.call).to eq %w[1 1 2 message-ok email-sent-hello]

      unstub

      expect_call_orig
    end

    it 'raises exception when calls a stub block' do
      expect {
        stub('CreateDeparture') { raise StandardError, 'Something went wrong' }
      }.not_to raise_error

      expect { CreateOrder.call }
        .to raise_error(StandardError, 'Something went wrong')

      unstub

      expect_call_orig
    end
  end
end
