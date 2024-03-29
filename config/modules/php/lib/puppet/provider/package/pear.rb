require 'puppet/provider/package'

# PHP PEAR support.
Puppet::Type.type(:package).provide :pear, :parent => Puppet::Provider::Package do
  desc "PHP PEAR support. By default uses the installed channels, but you
        can specify the path to a pear package via ``source``."
  
  has_feature :versionable
  has_feature :upgradeable
  
  commands :pearcmd => "pear"

  def self.pearlist(hash)
    command = [command(:pearcmd), "list"]

    begin
      list = execute(command).collect do |set|
        if hash[:justme]
          if  set =~ /^hash[:justme]/
            if pearhash = pearsplit(set)
              pearhash[:provider] = :pear
              pearhash
            else
              nil
            end
          else
            nil
          end
        else
          if pearhash = pearsplit(set)
            pearhash[:provider] = :pear
            pearhash
          else
            nil
          end
        end

      end.reject { |p| p.nil? }
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::Error, "Could not list pears: %s" % detail
    end

    if hash[:justme]
      return list.shift
    else
      return list
    end
  end

  def self.pearsplit(desc)
    case desc
    when /^INSTALLED/: return nil
    when /^=/: return nil
    when /^PACKAGE/: return nil
    when /^(\S+)\s+([.\d]+)\s+\S+\n/
      name = $1
      version = $2
      return {
        :name => name,
        :ensure => version
      }
    else
      Puppet.warning "Could not match %s" % desc
      nil
    end
  end

  def self.instances
    pearlist(:local => true).collect do |hash|
      new(hash)
    end
  end

  def install(useversion = true)
    command = ["upgrade"]

    if source = @resource[:source]
      command << source
    else
      if (! @resource.should(:ensure).is_a? Symbol) and useversion
#        command << "-f"
        command << "#{@resource[:name]}-#{@resource.should(:ensure)}"
      else
        command << @resource[:name]
      end
    end

    pearcmd(*command)
  end

  def latest
    # This always gets the latest version available.
    version = ''
    command = [command(:pearcmd), "remote-info", @resource[:name]]
      list = execute(command).collect do |set|
      if set =~ /^Latest/
        version = set.split[1]
      end
    end
    return version
  end

  def query
    self.class.pearlist(:justme => @resource[:name])
  end

  def uninstall
    output = pearcmd "uninstall", @resource[:name]
    if output =~ /^uninstall ok/
    else
      raise Puppet::Error, output
    end
  end

  def update
    self.install(false)
  end
end

