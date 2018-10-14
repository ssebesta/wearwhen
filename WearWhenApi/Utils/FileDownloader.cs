using System;
using System.IO;

namespace WearWhenApi.Utils
{
    public class FileDownloader
    {
        public static byte[] GetFile(string filePath)
        {            
            string documents = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            string fileName = Path.Combine(documents, filePath);

            // Load file meta data with FileInfo
            FileInfo fileInfo = new FileInfo(fileName);

            // The byte[] to save the data in
            byte[] fileBytes = new byte[fileInfo.Length];

            // Load a filestream and put its content into the byte[]
            using (FileStream fs = fileInfo.OpenRead())
            {
                fs.Read(fileBytes, 0, fileBytes.Length);
            }

            // Delete the temporary file
            //fileInfo.Delete();

            return fileBytes;
        }

        public FileDownloader()
        {
        }
    }
}
