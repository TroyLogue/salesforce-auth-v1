def create_consent_file(file_name)
    f = File.open(file_name, 'w+'){|f| f.write("I give consent.") }
    File.expand_path("../../#{file_name}", __FILE__)
end

def delete_consent_file(file_name)
    File.delete(file_name)
end
