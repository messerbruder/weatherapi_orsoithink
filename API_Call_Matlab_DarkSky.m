url = 'https://api.darksky.net/forecast/a40f38a7e918fb1d240f8489558fc6cf/47.37,8.54?units=si';
% Carefull!
for run4ever = 1:10

    data = urlread(url);

    data(strfind(data,'{')) = [];
    data(strfind(data,'}')) = ';';

    data(strfind(data,'"')) = [];

    extract_time = extractBetween(data,"time:",",summary");
    extract_cloudcover = extractBetween(data,"cloudCover:",",uvIndex");
    extract_temperature = extractBetween(data,"temperature:",",apparentTemperature");


    Time_char = cell2mat(extract_time);
    Temperature = zeros(1,24);
    Cloudiness = zeros(1,24);
    U = zeros(1,length(Time_char)); %height is # of row

    for i = 1:24
        Temperature(i) = str2double(extract_temperature{i+1,1});
        Cloudiness(i) = str2double(extract_cloudcover{i+1,1});
        U(i) = str2num(Time_char(i+1,:));
        realDate(i) = unixTimeToDateNum(U(i));
    end


    MatlabAPI_Call = fopen('Matlab_Weather.csv','w+');
    fprintf(MatlabAPI_Call,'year,month,day,hour,temperature,cloudiness \n');
    fclose(MatlabAPI_Call);
    MatlabAPI_Call = fopen('Matlab_Weather.csv','a');


    for i = 1:24
        format_date = datestr(realDate(i),'yyyy,mm,dd,HH');

        fprintf(MatlabAPI_Call,format_date);
        fprintf(MatlabAPI_Call,',');
        fprintf(MatlabAPI_Call,num2str(Temperature(i)));
        fprintf(MatlabAPI_Call,',');
        fprintf(MatlabAPI_Call,num2str(Cloudiness(i)*10));
        fprintf(MatlabAPI_Call,'\n');

        disp([format_date,'  ' ,num2str(Temperature(i)),'   ', num2str(Cloudiness(i)*10)]);
        

    end
    fclose(MatlabAPI_Call);
    disp('------------------------------------------------------------------------');
    pause(10)
end
