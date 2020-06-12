from .Database import Database


class DataRepository:
    @staticmethod
    def json_or_formdata(request):
        if request.content_type == 'application/json':
            gegevens = request.get_json()
        else:
            gegevens = request.form.to_dict()
        return gegevens

    @staticmethod
    def get_rides():
        sql = "SELECT * FROM rides"

        return Database.get_rows(sql)
    
    @staticmethod
    def get_ride_stats(rideid):
        sql = "SELECT * FROM stats_ride WHERE rideid=%s"

        params = [rideid]

        return Database.get_one_row(sql, params)
    
    @staticmethod
    def get_ride_history(rideid):

        # sql = "SELECT actionid, value,  date_format(date, '%h:%m:%\\s') as date, reference, rideid FROM history WHERE rideid=%s ORDER BY date"
        sql = "SELECT * FROM history WHERE rideid=%s ORDER BY date"

        params = [rideid]

        return Database.get_rows(sql, params)

    @staticmethod
    def create_log_temp(value, rideid):
        sql = 'INSERT INTO history (value, actionid, rideid) VALUES (%s, "TEMP", %s)'

        params = [value, rideid]

        return Database.execute_sql(sql, params)
    
    @staticmethod
    def create_log_light(value, rideid):
        sql = 'INSERT INTO history (value, actionid, rideid) VALUES (%s, "LIGHT", %s)'

        params = [value, rideid]

        return Database.execute_sql(sql, params)
    
    @staticmethod
    def create_log_accel(value, rideid):
        sql = 'INSERT INTO history (value, actionid, rideid) VALUES (%s, "ACCEL", %s)'

        params = [value, rideid]

        return Database.execute_sql(sql, params)
    
    @staticmethod
    def create_log_angle(value, rideid):
        sql = 'INSERT INTO history (value, actionid, rideid) VALUES (%s, "ANGLE", %s)'

        params = [value, rideid]

        return Database.execute_sql(sql, params)

    @staticmethod
    def create_new_ride():
        sql = "INSERT INTO `rides` (`rideid`) VALUES (NULL)"

        return Database.execute_sql(sql)

    @staticmethod
    def get_ride_summaries():
        sql = "SELECT a.max_angle, t.avg_temp, r.rideid, r.ridename, date_format(starttime, '%d-%m-%Y') as `date` FROM rides as r "
        sql += "LEFT JOIN avg_temp_ride AS t ON r.rideid = t.rideid "
        sql += "LEFT JOIN max_angle_ride AS a ON r.rideid = a.rideid"       
        
        return Database.get_rows(sql)
    	
    @staticmethod
    def get_month_summary(month):
        sql = "SELECT * FROM summary_months WHERE date=%s"

        params = [month]

        return Database.get_one_row(sql, params)

    @staticmethod
    def get_months():
        sql = "SELECT date FROM summary_months"

        return Database.get_rows(sql)

    @staticmethod
    def delete_ride(rideid):
        sql = "DELETE FROM history WHERE rideid=%s"
        params = [rideid]

        Database.execute_sql(sql,params)

        sql = "DELETE FROM rides WHERE rideid=%s"

        return Database.execute_sql(sql, params)
    
    @staticmethod
    def update_ride(rideid, ridename, ridedescription):
        sql = "UPDATE rides SET ridename = %s, description = %s WHERE rideid = %s"

        params = [ridename, ridedescription, rideid]
        
        return Database.execute_sql(sql, params)


    @staticmethod
    def get_current_ride():
        sql = "SELECT max(rideid) as rideid FROM rides"

        return Database.get_one_row(sql)