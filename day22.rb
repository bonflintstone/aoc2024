seeds = File.read('./day22input.txt').split.map(&:to_i)

def mix_and_prune(number, secret)
  (number ^ secret) % (2 ** 24)
end

def gen(secret)
  secret = mix_and_prune(secret * 64, secret)
  secret = mix_and_prune(secret / 32, secret)
  secret = mix_and_prune(secret * 2048, secret)
end

CHANGE_HISTORY_PRICES = {}
def do_the_thing(seed, i)
  change_history = []
  2000.times do
    new = gen(seed)
    change_history.push((new % 10) - (seed % 10))
    change_history.shift if change_history.length > 4

    if change_history.length == 4
      CHANGE_HISTORY_PRICES[change_history.to_s] ||= []
      CHANGE_HISTORY_PRICES[change_history.to_s][i] ||= new % 10
    end

    seed = new
  end
  seed
end

puts seeds.each_with_index.sum { |seed, i| do_the_thing(seed, i) }

puts CHANGE_HISTORY_PRICES.values.map(&:compact).map(&:sum).max
