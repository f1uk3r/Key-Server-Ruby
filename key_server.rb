require 'set'

class KeyServer
  attr_reader :keys, :available_keys

  def initialize
    @keys = {}
    @available_keys = Set.new
    @deleted_keys = Set.new
    @testing_variable = nil
    Thread.new do
      loop do
        sleep 1
        continuous_job
      end
    end
  end

  def random_key
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...8).map { o[rand(o.length)] }.join
  end

  def generate_keys(count)
    count.times do
      current_key = random_key
      while @keys[current_key] || @deleted_keys.include?(current_key)
        current_key = random_key
      end
      @keys[current_key] = {
        'expiry_time' => Time.now + (5*60)
      }
      @available_keys.add current_key
    end
    @available_keys
  end

  def get_available_key
    output = nil
    @available_keys.each do |key|
      output = key
      @keys[key]['block_time'] = Time.now + 60
      break
    end
    @available_keys.delete output
    @testing_variable = output
    return output
  end

  def unblock_key(key)
    output = false
    begin
      if @keys[key]['block_time'] && @keys[key]
        @keys[key] = {
          'expiry_time' => Time.now + (5*60)
        }
        output = key
        @available_keys.add output
      end
    rescue NoMethodError => e
      puts e
    end
    return output
  end

  def delete_key(key)
    output = false
    begin
      if @keys[key] || @available_keys.include?(key)
        if @keys[key]
          @keys.delete(key)
        end
        if @available_keys.include?(key)
          @available_keys.delete(@key)
        end
        output = key
        @deleted_keys.add key
      else
        return nil
      end
    rescue NoMethodError => e
      puts e
    end
    return output
  end

  def stayin_alive(key)
    output = nil
    begin
      if @keys[key]
        @keys[key] = {
          'expiry_time' => Time.now + (5*60)
        }
        output = key
      else
        return nil
      end
    rescue NoMethodError => e
      puts e
    end
  end

  def continuous_job
    @keys.each do |key, value|
      unblock_key(key) if value['block_time'] && value['block_time'] < Time.now
      delete_key(key) if value['expiry_time'] < Time.now
    end
  end
end

if __FILE__ == $0
  server = KeyServer.new
  server.generate_keys(5)
  server.get_available_key
  server.delete_key
end