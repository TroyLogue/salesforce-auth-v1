def create_consent_file(file_name)
    f = File.open(file_name, 'w+'){|f| f.write("I give consent.") }
    File.expand_path("../../#{file_name}", __FILE__)
end

def delete_consent_file(file_name)
    File.delete(file_name)
end

def get_signature_image
    file = File.open("lib/files/signature_image.txt")
    file_content = file.read
    file.close
    return file_content
end
