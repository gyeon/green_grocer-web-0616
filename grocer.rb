def consolidate_cart(cart)
  #given a hash I need to take the key and if they're the same,
  #put them in a new key/value pair of count:

  # 1. first create a new hash for the updated cart
  updated_cart = {}
  # 2. then go iterate through the cart, AND the hash of items
  cart.each do |data_hash|
    data_hash.each do |item, attributes|
  # 3. If the updated cart does NOT include the item (it won't at first because it's a new cart)
  #    put the item and the attributes in the updated cart. Also add a new attribute
  #    of count and set it equal to 1.
      if !updated_cart.include?(item)
        updated_cart[item] = attributes
        updated_cart[item][:count] = 1
      else
  # 4. If it does include the item, increment the count.
        updated_cart[item][:count] += 1
      end
    end
  end
  # 5. return the updated cart.
  updated_cart
end

def apply_coupons(cart, coupons)
  # {"AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
  #  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}}
  # coupon hash {:item => "AVOCADO", :num => 2, :cost => 5.0}

  #we want this:
  # {"AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
    # "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
    # "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},}

  #Ok, so how can we tell what to discount? Go through the coupons and match
  # the item to the cart's item name.

  # 1. Go through the coupons
  coupons.each do |coupon|
  # 2. set the coupon item to a variable
    name = coupon[:item]
  # 3. Check to see if the coupon item is same as cart item and if the count is the same.
    if cart[name] && cart[name][:count] >= coupon[:num]
  # 4. Check to see if coupon is already in the cart. If so, increment coupon
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
  # 5. If not, add that to cart with attributes of count & price
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
  # 6. Also add a clearance attribute to w/coupon with the cart item's clearance
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
  # 7. Then subtract the count of cart item from the coupon item's count
      cart[name][:count] -= coupon[:num]
    end
  end
  # 8. Return the cart
  cart
end

def apply_clearance(cart)
  # if the cart item's clearance is true, take 20% off the price
  # Go through the cart to see if item is on clearance.

  # 1. Iterate through cart
  cart.each do |item, attributes|
    if attributes[:clearance] == true
  # 2. Take 20% off the full price.
      discount = attributes[:price] * 0.2
  # 3. Set the discounted price to the attributes price
      attributes[:price] = attributes[:price] - discount
    end
  end
  # 4. Return cart
  cart
end

def checkout(cart, coupons)
  # IRL how would I do this?
    # - Go through the cart and group all the items (consolidate)
    # - Apply any coupons they may have
    # - Check to see if the item is on clearance and if it is, apply the discount
    # - Add the item's prices together.

  # 1. Consolidate the cart
  consolidated_cart = consolidate_cart(cart)
  # 2. Apply coupons
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  # 3. Check to see if on clearance
  clearanced_cart = apply_clearance(couponed_cart)
  # 4. Set the total to 0
  total = 0
  # 5. Since the clearanced_cart is the last thing we check it's the most updated
  #    and we'll need to go through each of the items and add the prices together.
  clearanced_cart.each do |item, attributes|
    total += attributes[:price] * attributes[:count]
  end
  # If, after applying the coupon discounts and the clearance discounts,
  # the cart's total is over $100, then apply a 10% discount.
  if total > 100
    discount = total * 0.1
    total = total - discount
  end
  total
end
