class Address
  attr_accessor :postcode, :street

  def initialize(params)
    @postcode = params[:postcode]
    @street = params[:street]
  end
end

class Person
  extend AttrValueObject
  attr_accessor :address_postcode, :address_street
  attr_accessor :billing_address_postcode, :billing_address_street

  attr_value_object :address
  attr_value_object :billing_address, class_name: 'Address'
end

RSpec.describe AttrValueObject do
  it "has a version number" do
    expect(AttrValueObject::VERSION).not_to be nil
  end

  describe "getter" do
    it "returns a new instance initialized with its attributes" do
    	p = Person.new
    	p.address_postcode = '100-0000'
    	p.address_street = 'test street'
      expect(p.address.postcode).to eq(p.address_postcode)
      expect(p.address.street).to eq(p.address_street)
    end
  end

  describe "setter" do
    it "sets each attribute of the passed object to attribute of itself" do
      p = Person.new
      address = Address.new(
        postcode: '100-0001',
        street: 'Foo street'
      )
      p.address = address
      expect(p.address_postcode).to eq(address.postcode)
      expect(p.address_street).to eq(address.street)
    end
  end

  describe "options" do
    describe "class_name" do
      it "binds specified class" do
        p = Person.new
        expect(p.billing_address).to be_a(Address)
        billing_address = Address.new(
          postcode: '100-0001',
          street: 'Foo street'
        )
        p.billing_address = billing_address
        expect(p.billing_address_postcode).to eq(billing_address.postcode)
        expect(p.billing_address_street).to eq(billing_address.street)
      end
    end
  end
end
