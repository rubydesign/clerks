

describe "Basket search functionality" do
  before(:each) do
    sign_in
  end
  # this adds the product to the basket as it finds exactly one
  it "adds product by entering ean" do
    visit_path new_basket_path
    p = create :product , :ean => "1234567891234"
    within ".ean_form" do
      fill_in "ean" , :with => "#{p.ean}"
      click_on I18n.t(:search)
    end
    td = find(".table").find(".name")
    expect(td).to have_content(p.name)
  end
  # this adds the product, but because we enter the name, it has to search and show a second page
  # where we hit add
  it "adds product by entering name" do
    basket = create :basket
    visit_path edit_basket_path(basket)
    p = create :product
    within ".ean_form" do
      fill_in "ean" , :with => "#{p.name[0 .. -3]}"
      click_on I18n.t(:search)
    end
    find(:xpath, "//tr[contains(., '#{p.name}')]/td/a", :text => I18n.t(:add_to_basket)).click
    td = find(".table").find(".name")
    expect(td).to have_content(p.name) # added the product, yes!
  end
  it "adds cost price for purchases" do
    basket = create(:empty_purchase).basket
    visit_path edit_basket_path(basket)
    p = create :product  , :ean => "1234567891234"
    within ".ean_form" do
      fill_in "ean" , :with => "#{p.ean}"
      click_on I18n.t(:search)
    end
    td = find("#basket_items_attributes_0_price")
    expect(td.value).to eq(p.cost.to_s)
  end

end
