import type { Metadata } from "next";
import { Roboto } from "next/font/google";
import "./globals.css";
import { ThemeProviders } from "@/provider/ThemeProvider";
import { Toaster } from "sonner";
import PrivateNavbar from "@/components/Navbar";

const roboto = Roboto({
  weight: ["100", "300", "400", "500", "700", "900"],
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Trung tâm anh ngữ đa chi nhánh",
  description: "",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={roboto.className}>
        <ThemeProviders>
          <PrivateNavbar />
          <Toaster closeButton position="top-center" richColors />
          {children}
        </ThemeProviders>
      </body>
    </html>
  );
}
