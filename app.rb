# --
# basic sinatra app to do three things:
# * tell you what app server is running this code (/server)
# * compute pi to 10,000 decimal places as a pseudo-task to fake real work
# * do a twitter search, simulating network wait
class AppServerArena < Sinatra::Base
  get '/' do
    index
  end

  get '/server' do
    server
  end

  get '/pi' do
    pi
  end

  get '/sleep' do
    do_sleep
  end

  get '/random' do
    do_random
  end

  get '/active_record' do
    do_active_record
  end

private
  def do_random
    num = 1 + rand(10) # random number b/t 1 and 10
    case num
    when 1..5
      server
    when 6..7
      do_sleep
    else
      pi
    end
  end

  def do_sleep
    sleep 1
    erb :sleep
  end

  def server
    # Figure out which app server we're running under
    @current_server = ENV['RACK_HANDLER']

    # Set the request and response objects for page rendering
    @request = request
    @response = response
    erb :server
  end

  def pi
    @pi = calc_pi(5_000)
    erb :pi
  end

  def index
    erb :index
  end

  def do_active_record
    @users = User.all
    erb :active_record
  end

  # These two methods are to be used for a semi-computationally expensive task,
  # simulating real wock without the loss of control that would come from
  # abdicating control to IO (e.g. database, HTTP API, file access, etc.)
  # Found at stack overflow:
  # http://stackoverflow.com/questions/3137594/how-to-create-pi-sequentially-in-ruby
  def arccot(x, unity)
   xpow = unity / x
   n = 1
   sign = 1
   sum = 0
   loop do
       term = xpow / n
       break if term == 0
       sum += sign * (xpow/n)
       xpow /= x*x
       n += 2
       sign = -sign
   end
   sum
  end

  def calc_pi(digits = 10000)
     fudge = 10
     unity = 10**(digits+fudge)
     pi = 4*(4*arccot(5, unity) - arccot(239, unity))
     pi / (10**fudge)
  end
end
