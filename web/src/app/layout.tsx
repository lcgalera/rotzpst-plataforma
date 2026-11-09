import type { Metadata } from "next";
import "@/styles/tokens.css";
import "@/styles/fonts.css";
import "@/styles/base.css";
import { PreloadFontes } from "./preload-fontes";

export const metadata: Metadata = {
  title: {
    default: "rotzx",
    template: "%s · rotzx",
  },
  description: "Economia, geopolítica e inteligência global, com fonte e data em cada dado.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="pt-BR">
      <body>
        <PreloadFontes />
        {children}
      </body>
    </html>
  );
}
