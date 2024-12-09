import { ReactNode } from "react";
import { twMerge } from "tailwind-merge";

interface Props {
  className?: string;
  children: ReactNode;
}

export default function List({ className, children }: Props) {
  const defaultClassName = "flex";
  return <ul className={twMerge(defaultClassName, className)}>{children}</ul>;
}
