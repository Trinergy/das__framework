require_relative '../database'

# Rough - tests assume you have a table with an existing record 'Kenny' created
describe Database do
  let(:db_url) { 'postgres://localhost/kenny_test' }
  let(:db) { Database.connect(db_url, queries) }
  let(:queries) {
    {
      all_submissions: %{
        SELECT * FROM submissions;
      },
      find_submission_by_name: %{
        SELECT * FROM submissions WHERE name = $1;
      }
    }
  }
  

  it 'does not have sql injection vulnerabilities' do
    name = "'; DROP TABLE submissions; --'"

    expect{db.find_submission_by_name(name)}.to change{db.all_submissions.length}.by(0)
  end

  it 'retrieves a record' do
    name = 'Kenny'
    query = db.find_submission_by_name(name).fetch(0)

    expect(query.name).to eq(name)
  end
end