import Image from "next/image";
import { twMerge } from "tailwind-merge";
import logo from "@/../public/logo.svg";

interface Props {
  className?: string;
}

export default function Logo({ className }: Props) {
  const defaultClassName = "cursor-pointer rounded-xl";
  return (
    <Image
      src={logo}
      alt="logo"
      width={50}
      height={50}
      className={twMerge(defaultClassName, className)}
    />
  );
}
