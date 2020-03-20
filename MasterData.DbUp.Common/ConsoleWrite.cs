using System;
using System.Collections.Generic;
using System.Text;

namespace MasterData.DbUp.Common
{
    public class ConsoleWrite
    {
        public static void WriteLine(String message, ConsoleColor color)
        {
            Console.ForegroundColor = color;
            Console.WriteLine(message);
            Console.ResetColor();
        }
        public static void Write(String message, ConsoleColor color)
        {
            Console.ForegroundColor = color;
            Console.Write(message);
            Console.ResetColor();
        }


        public static void Success(String message)
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine(message);
            Console.ResetColor();
        }

        public static void Error(Exception exception)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine(exception);
            Console.ResetColor();
#if DEBUG
            Console.ReadLine();
#endif
        }

        public static void Error(String message)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine(message);
            Console.ResetColor();
        }

        public static void Info(String message)
        {
            Console.WriteLine(message);
        }
    }
}
