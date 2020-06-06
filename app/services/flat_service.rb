class FlatService
  class << self
    def get_user(session_key)
      get_json(conn(session_key).get('/v2/me'))
    end

    def get_scores(user_id, session_key)
      response = conn(session_key).get("/v2/users/#{user_id}/scores")
      response.body.empty? ? [] : get_json(response)
    end

    def get_score(score_id, session_key)
      get_json(conn(session_key).get("/v2/scores/#{score_id}"))
    end

    def delete_score(score_id, session_key)
      conn(session_key).delete("/v2/scores/#{score_id}")
    end

    def add_collaborator(score_id, user_id, session_key)
      body = { 'user': user_id,
               'aclWrite': true }
      conn(session_key).post("/v2/scores/#{score_id}/collaborators") do |request|
        request.headers['content-type'] = 'application/json'
        request.body = body.to_json
      end
    end

    def create_score(title, clef, session_key)
      resp = conn(session_key).post('/v2/scores') do |request|
        request.headers['content-type'] = 'application/json'
        request.body = body(title, template(clef)).to_json
      end
      get_json(resp)
    end

    private

    def conn(session_key)
      Faraday.new('https://api.flat.io') do |f|
        f.headers[:Authorization] = "Bearer #{session_key}"
      end
    end

    def get_json(resp)
      JSON.parse(resp.body, symbolize_names: true)
    end

    def body(title, enc)
      {
        'title': title,
        'privacy': 'public',
        'data': enc,
        'dataEncoding': 'base64'
      }
    end

    def template(clef)
      file = template_select(clef)
      Base64.encode64(file).to_s
    end

    def template_select(clef)
      return File.read('./xml_files/template.musicxml') if clef == 'Treble'

      return File.read('./xml_files/bass_template.musicxml') if clef == 'Bass'

      File.read('./xml_files/combo.musicxml')
    end
  end
end
