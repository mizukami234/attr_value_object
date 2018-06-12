# Getting started

`attr_value_object` is a minimalistic module.

`attr_value_object` is needed in the case when you have a model with multiple fields to represent the dependent property and you want to separate logic. Address of user for example. The fields are `postcode`, `prefecture_id`, `street` and `building`. If you are using Ruby on Rails, you may add columns into users with a migration. You may want them to indicate a same property (address) explicitly. So the `User` model looks like following.

```rb
# ActiveRecord is not required.
# It's enough for `attr_value_object` to work if only these accessors are defined.

class User
  attr_accessor :address_postcode,
                :address_prefecture_id,
                :address_street,
                :address_building
end
```

If another model has the same property (address) and you want to `JOIN` based on `addresses`, it's good to create `addresses` table. But there is the case you don't need such a function. This is inevitable because the available types of database column is finite. However, you may still want to separate logic. Then, you can do it with creating `Address` class and specifying `attr_value_object`.

```rb
class Address
  attr_accessor :postcode,
                :prefecture_id,
                :street,
                :building
end

class User
  extend AttrValueObject

  attr_accessor :address_postcode,
                :address_prefecture_id,
                :address_street,
                :address_building

  attr_value_object :address
end

address = Address.new
address.postcode = '1000000'
address.prefecture_id = 1
address.street = 'Foo Bar Street'
address.building = 'AVO Building 34F'

user = User.new

# setter
user.address = address
user.address_postcode # => '1000000'

# getter
user.address # => #<Address> always new instance
```

# API

### `#attr_value_object(name, options = {})`

The binding class is inferred from name unless `class_name` option is specified.

# ToDo

- work with rails validations
- attribute mapping flexibility
