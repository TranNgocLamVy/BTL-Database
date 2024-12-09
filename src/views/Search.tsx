"use client";
import FlexBox from "@/components/Box/FlexBox";
import Searchbar from "@/components/Searchbar";
import { Select, SelectItem } from "@nextui-org/react";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

interface Props {
  param: SearchParams;
}

export default function Search({ param }: Props) {
  const router = useRouter();

  const [params, setParams] = useState<SearchParams>(param);

  useEffect(() => {
    setParams(param);
  }, [param]);

  const onChange = (value: string) => {
    setParams({ ...params, value });
  };

  const onSearch = () => {
    router.push(
      `nhanvien/?type=${params.type}&field=${params.field}&value=${params.value}`
    );
  };

  return (
    <FlexBox className="justify-center gap-4">
      <Select
        onChange={(e) => setParams({ ...params, field: e.target.value })}
        placeholder="Tìm kiếm bằng"
        radius="sm"
        variant="bordered"
        defaultSelectedKeys={[params.field || "Ten"]}
        className="w-48 bg-white rounded-md">
        <SelectItem key="Ten" value="Ten">
          Tìm bằng tên
        </SelectItem>
        <SelectItem key="Email" value="Email">
          Tìm bằng email
        </SelectItem>
        <SelectItem key="SDT" value="SDT">
          Tìm bằng SDT
        </SelectItem>
        <SelectItem key="NamSinh" value="NamSinh">
          Tìm bằng năm sinh
        </SelectItem>
      </Select>
      <Searchbar
        onSearch={onSearch}
        value={params.value}
        onChange={onChange}
        placeholder="Tìm kiếm nhân viên"
        className="w-96 bg-white rounded-md"
      />
    </FlexBox>
  );
}
