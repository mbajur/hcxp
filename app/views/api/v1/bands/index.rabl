object false

child @bands => :bands do
  collection @bands

  extends 'api/v1/bands/band'
end

node(:resource) { 'bands' }