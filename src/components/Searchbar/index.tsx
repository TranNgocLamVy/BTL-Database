import { Input } from "@nextui-org/react";
import { MagnifyingGlass } from "@phosphor-icons/react";

interface Props {
  className?: string;
  placeholder?: string;
  value?: string;
  onChange?: (value: string) => void;
  onSearch?: () => void;
}

export default function Searchbar({
  className,
  placeholder,
  value,
  onChange,
  onSearch,
}: Props) {
  return (
    <form
      className={className}
      onSubmit={(e) => {
        e.preventDefault();
        onSearch?.();
      }}>
      <Input
        radius="sm"
        size="md"
        variant="bordered"
        placeholder={placeholder}
        value={value}
        onChange={(e) => onChange?.(e.target.value)}
        onSubmit={onSearch}
        startContent={
          <MagnifyingGlass
            onClick={onSearch}
            className="cursor-pointer"
            size={20}
            weight="bold"
          />
        }
      />
    </form>
  );
}
