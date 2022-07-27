module Print

  def rakennus
    load_order
    @template = "rakennus"
  end
  def ecoframe
    load_order
    @template = "ecoframe"
  end

  def invoice
    load_order
    @invoice = true
    @template = "invoice"
  end

  # slip is an invoice without prices
  def slip
    load_order
    @slip = true
    @template = "slip"
    render "invoice"
  end

  # reminder is an invoice with an extra text to kindly pay up
  def reminder
    load_order
    @reminder = true
    @template = "reminder"
    render "invoice"
  end

  def xml
    render "finvoice.xml" , content_type: "application/xml" , layout: false
  end
end
