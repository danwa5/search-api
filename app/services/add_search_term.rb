class AddSearchTerm
  include Services::BaseService

  def initialize(term: term)
    @term = String(term).downcase
  end

  def call
    return if @term.blank?

    SearchTerm.find_or_create_by!(block_time: block_time, term: @term).increment!(:search_count)

    true
  end

  private

  def time
    @time ||= Time.now
  end

  def block_time
    hour = time.at_beginning_of_hour
    minutes = time.strftime('%M').to_i

    rounded_minutes = case minutes
      when 0..14 then 0
      when 15..29 then 15
      when 30..44 then 30
      when 45..59 then 45
      end

    hour + rounded_minutes.minutes
  end
end
