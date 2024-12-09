import { CSSProperties, ReactNode } from "react";

interface Props {
  className?: string;
  children?: ReactNode;
  style?: CSSProperties;
  onClick?: () => void;
}

export default function ListItem({
  className,
  children,
  style,
  onClick,
}: Props) {
  return (
    <li onClick={onClick} className={className} style={style}>
      {children}
    </li>
  );
}
