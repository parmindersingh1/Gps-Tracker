class GpstrackerController < ApplicationController
  require 'cgi'
  def displaymap_blue
  end
  
  def getallroutesformap
#     
    # BEGIN
  # SELECT DISTINCT(sessionId), MAX(gpsTime) gpsTime, 
  # CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationMethod":"', locationMethod, '", "gpsTime":"', DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionID":"', CAST(sessionID AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extraInfo":"', extraInfo, '" }') json
  # FROM gpslocations
  # WHERE sessionID != '0' && CHAR_LENGTH(sessionID) != 0 && gpstime != '0000-00-00 00:00:00'
  # GROUP BY sessionID;
# END ;;
    @locations=[] 
    @locations=Gpslocation.where("sessionID != '0' && CHAR_LENGTH(sessionID) != 0 && gpstime != '0000-00-00 00:00:00'").group(:sessionID)
    # @locations= Gpslocation.getallroutesformap
       
    render :json =>  {:locations=> @locations}
  end
  
  def getrouteformap
    
    
    # BEGIN
  # SELECT CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationMethod":"', locationMethod, '", "gpsTime":"', DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionID":"', CAST(sessionID AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extraInfo":"', extraInfo, '" }') json
  # FROM gpslocations
  # WHERE sessionID = _sessionID
  # ORDER BY lastupdate;
# END

    @locations=[] 
    @locations=Gpslocation.where("sessionID = '#{params[:sessionid]}'").order("updated_at DESC")
   
  render :json =>  {:locations=> @locations}
  end
  
  def getroutes
    
    # BEGIN
    # CREATE TEMPORARY TABLE tempRoutes (
    # sessionID VARCHAR(50),
    # userName VARCHAR(50),
    # startTime DATETIME,
    # endTime DATETIME)
  # ENGINE = MEMORY;
# 
  # INSERT INTO tempRoutes (sessionID, userName)
  # SELECT DISTINCT sessionID, userName
  # FROM gpslocations;
# 
  # UPDATE tempRoutes tr
  # SET startTime = (SELECT MIN(gpsTime) FROM gpslocations gl
  # WHERE gl.sessionID = tr.sessionID
  # AND gl.userName = tr.userName);
# 
  # UPDATE tempRoutes tr
  # SET endTime = (SELECT MAX(gpsTime) FROM gpslocations gl
  # WHERE gl.sessionID = tr.sessionID
  # AND gl.userName = tr.userName);
# 
  # SELECT
# 
  # CONCAT('{ "sessionID": "', CAST(sessionID AS CHAR),  '", "userName": "', userName, '", "times": "(', DATE_FORMAT(startTime, '%b %e %Y %h:%i%p'), ' - ', DATE_FORMAT(endTime, '%b %e %Y %h:%i%p'), ')" }') json
  # FROM tempRoutes
  # ORDER BY startTime DESC;
# 
  # DROP TABLE tempRoutes;
    # END
    @routes=[];
    route=Hash.new
    
    @distinct_sessions=Gpslocation.select(:sessionID, :userName).distinct
    @distinct_sessions.each do |session|
      route={}
      route["sessionID"]=session.sessionID
      route["userName"]=session.userName
      startTime=Gpslocation.where("sessionID = '#{session.sessionID}'  AND userName = '#{session.userName}'").minimum('gpsTime')
      endTime=Gpslocation.where("sessionID = '#{session.sessionID}'  AND userName = '#{session.userName}'").maximum('gpsTime')
      
      if startTime.nil?
        startTime = CGI::unescape('0000-00-00')
      end 
      if endTime.nil?
        endTime = CGI::unescape('0000-00-00')
      end
      
      puts "---------------------#{startTime}----------#{endTime}"
      route["times"]="#{startTime.strftime('%b %e %Y %I:%M%p')} - #{endTime.strftime('%b %e %Y %I:%M%p')}"
      
      @routes << route
    end   
    render :json =>  {:routes=> @routes}
  end
  
  def updatelocation
    
    # CREATE DEFINER=`root`@`localhost` PROCEDURE `prcSaveGPSLocation`(
# _latitude DECIMAL(10,7),
# _longitude DECIMAL(10,7),
# _speed INT(10),
# _direction INT(10),
# _distance DECIMAL(10,1),
# _date TIMESTAMP,
# _locationMethod VARCHAR(50),
# _userName VARCHAR(50),
# _phoneNumber VARCHAR(50),
# _sessionID VARCHAR(50),
# _accuracy INT(10),
# _extraInfo VARCHAR(255),
# _eventType VARCHAR(50)
# )
# BEGIN
   # INSERT INTO gpslocations (latitude, longitude, speed, direction, distance, gpsTime, locationMethod, userName, phoneNumber,  sessionID, accuracy, extraInfo, eventType)
   # VALUES (_latitude, _longitude, _speed, _direction, _distance, _date, _locationMethod, _userName, _phoneNumber, _sessionID, _accuracy, _extraInfo, _eventType);
   # SELECT NOW();
# END ;;


    puts "--------------------#{params}"
    location={}
    location["latitude"] = params['latitude'].present? ? params['latitude'].gsub(',', '.').to_f : '0'
    location["longitude"] = params['longitude'].present? ? params['longitude'].gsub(',', '.').to_f : '0'
    location["speed"] = params['speed'].present? ? params['speed'] : 0
    location["direction"] = params['direction'].present? ? params['direction'] : 0
    location["distance"] = params['distance'].present?  ? params['distance'].gsub(',', '.').to_f : '0'
    location["gpsTime"] = params['date'].present? ?  CGI::unescape(params['date']) :  Time.now
    location["locationMethod"] = params['locationmethod'].present? ?  CGI::unescape(params['locationmethod']) : ''
    location["userName"] = params['username'].present? ? params['username'] : 0
    location["phoneNumber"] = params['phonenumber'].present? ? params['phonenumber'] : ''
    location["sessionID"] = params['sessionid'].present? ? params['sessionid'] : 0
    location["accuracy"] = params['accuracy'].present? ? params['accuracy'] : 0
    location["extraInfo"] = params['extrainfo'].present? ? params['extrainfo'] : ''
    location["eventType"] = params['eventtype'].present? ? params['eventtype'] : ''
    
   @gpslocation = Gpslocation.new(location)
   if @gpslocation.save
     logger.info("location saved #{@gpslocation.id}")
     else 
     logger.info("Error while Saving location #{@gpslocation.errors}")
   end
       
   render nothing: true   
  end
  
  def deleteroute
    # CREATE DEFINER=`root`@`localhost` PROCEDURE `prcDeleteRoute`(
# _sessionID VARCHAR(50))
# BEGIN
  # DELETE FROM gpslocations
  # WHERE sessionID = _sessionID;
# END ;;
  session = params["sessionid"].present? ? params["sessionid"] : '0'
  @gpslocation = Gpslocation.find_by_sessionID(session)
  if @gpslocation.destroy 
      logger.info("location deleted ")
     else 
     logger.info("Error while deleting location #{@gpslocation.errors}")
  end
  render :json=>{:success => true}
  end
end
