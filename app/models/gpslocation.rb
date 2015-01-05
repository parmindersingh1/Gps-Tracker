class Gpslocation < ActiveRecord::Base
  # attr_accessor :maxgpstime
  
  def self.getallroutesformap
    @location=Gpslocation.find_by_sql(%Q{
    SELECT  CAST(latitude AS CHAR), CAST(longitude AS CHAR), CAST(speed AS CHAR), CAST(direction AS CHAR), CAST(distance AS CHAR), locationMethod, DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), userName,  phoneNumber, CAST(sessionID AS CHAR), CAST(accuracy AS CHAR), extraInfo 
    FROM gpslocations  WHERE sessionID != '0' && CHAR_LENGTH(sessionID) != 0 && gpstime != '0000-00-00 00:00:00'  GROUP BY sessionID;})
    return @location
  end
end
