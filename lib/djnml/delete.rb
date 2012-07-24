class DJNML
  class Delete
    attr_reader :product, :doc_date, :seq, :publisher, :reason

    def initialize(args = {})
      @product = args[:product] if args[:product]
      @doc_date = Time.parse(args[:doc_date]) if args[:doc_date]
      @seq = args[:seq].to_i if args[:seq]
      @publisher = args[:publisher] if args[:publisher]
      @reason = args[:reason] if args[:reason]
    end
  end
end
