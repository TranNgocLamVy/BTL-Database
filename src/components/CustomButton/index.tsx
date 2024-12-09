import { Button } from "@nextui-org/react";
import { ReactNode } from "react";

type Props = {
  children: ReactNode;
  className?: string;
  size?: "sm" | "md" | "lg";
  onClick?: () => void;
};

export default function CustomButton({ children, className, onClick }: Props) {
  return (
    <Button className={className} radius="sm" onClick={onClick}>
      {children}
    </Button>
  );
}
