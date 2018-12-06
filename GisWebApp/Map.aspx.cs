using System;
using System.Data;
using System.Globalization;
using System.Windows.Forms;
using Npgsql;

namespace GisWebApp
{
    public partial class Map : System.Web.UI.Page
    {
        private static NpgsqlConnection _connection;

        protected void Page_Load(object sender, EventArgs e)
        {
            Initialize();
        }

        private void Initialize()
        {
            string connectionString = "Server=127.0.0.1;Password=patrik;Database=pdt;User Id=postgres;Port=5432;";
            _connection = new NpgsqlConnection(connectionString);
        }

        private static bool OpenConnection()
        {
            try
            {
                _connection.Open();
                return true;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
        }

        private static bool CloseConnection()
        {
            try
            {
                _connection.Close();
                return true;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
        }

        private static string ExecuteQuery(NpgsqlCommand cmd)
        {
            string geojson = string.Empty;

            OpenConnection();
            cmd.Connection = _connection;
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 90000;

            NpgsqlDataReader dr = cmd.ExecuteReader();

            geojson = "{'type': 'FeatureCollection', 'features': [";
            while (dr.Read())
            {
                geojson += $"{dr["geojson"]}, ";
            }
            geojson = geojson.Substring(0, geojson.Length - 2);
            geojson += "]}"; 
            geojson = geojson.Replace("'", "\"");
            dr.Close();

            CloseConnection();
            
            return geojson;
        }

        [System.Web.Services.WebMethod]
        public static string GetRunWays(string longitude, string latitude)
        {
            try
            {
                string sqlQuery = "SELECT public.\"GetRunWays\"(:pLongitude, :pLatitude) AS geojson";
                NpgsqlCommand cmd = new NpgsqlCommand(sqlQuery);
                cmd.Parameters.AddWithValue("pLongitude", float.Parse(longitude, CultureInfo.InvariantCulture));
                cmd.Parameters.AddWithValue("pLatitude", float.Parse(latitude, CultureInfo.InvariantCulture));

                return ExecuteQuery(cmd);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetWayInLength(string longStart, string latStart, string length)
        {
            try
            {
                string sqlQuery = "SELECT public.\"GetWayInLength\"(:pLongStart, :pLatStart, :pLength) AS geojson";
                NpgsqlCommand cmd = new NpgsqlCommand(sqlQuery);
                cmd.Parameters.AddWithValue("pLongStart", float.Parse(longStart, CultureInfo.InvariantCulture));
                cmd.Parameters.AddWithValue("pLatStart", float.Parse(latStart, CultureInfo.InvariantCulture));
                cmd.Parameters.AddWithValue("pLength", int.Parse(length, CultureInfo.InvariantCulture));

                return ExecuteQuery(cmd);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetGyms(string longitude, string latitude)
        {
            try
            {
                string sqlQuery = "SELECT public.\"GetGyms\"(:pLongitude, :pLatitude) AS geojson";
                NpgsqlCommand cmd = new NpgsqlCommand(sqlQuery);
                cmd.Parameters.AddWithValue("pLongitude", float.Parse(longitude, CultureInfo.InvariantCulture));
                cmd.Parameters.AddWithValue("pLatitude", float.Parse(latitude, CultureInfo.InvariantCulture));

                return ExecuteQuery(cmd);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}