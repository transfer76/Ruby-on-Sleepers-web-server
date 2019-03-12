class BasicController
  attr_accessor :response
  attr_accessor :params
  attr_accessor :template_name

  def initialize
    @templates = {}
    
    Dir['./views/*.rhtml'].each do |file|
      @templates[File.basename(file, '.*')] = File.read(file)
    end
  end

  def action(method_name, params)
    self.params = params

    self.template_name = method_name 

    self.send(method_name)

    self.response = render(template_name)
  end

  def render(template_name)
    template = @templates[template_name]
    return nil unless template 

    result = template.gsub(/@\w+/) do |match|
      if self.instance_variable_defined?(match)
        self.instance_variable_get(match)
      else
        match
      end
    end

    return result
  end
end
