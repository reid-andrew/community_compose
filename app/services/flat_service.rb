class FlatService
  class << self
    attr_accessor :flat_key

    def get_user
      get_json(conn.get('/v2/me'))
    end

    def get_scores
      get_json(conn.get('/v2/users/me/scores'))
    end

    def get_score(score_id)
      get_json(conn.get("/v2/scores/#{score_id}"))
    end

    private

    def conn
      Faraday.new('https://api.flat.io') do |f|
        f.headers[:Authorization] = "Bearer #{@flat_key}"
      end
    end

    def get_json(resp)
      JSON.parse(resp.body, symbolize_names: true)
    end
  end
end
