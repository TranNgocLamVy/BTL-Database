"use client";
import FlexBox from "@/components/Box/FlexBox";
import { Pagination } from "@nextui-org/react";
import { useRouter } from "next/navigation";

interface Props {
  searchParam: SearchParams;
  countNhanVien: number;
}

export default function CustomPagnitation({
  searchParam,
  countNhanVien,
}: Props) {
  const router = useRouter();

  const onChangePage = (page: number) => {
    router.push(
      `nhanvien/?type=${searchParam.type}&field=${searchParam.field}&value=${searchParam.value}&page=${page}`,
      {
        scroll: false,
      }
    );
  };

  return (
    <FlexBox className="justify-center">
      {countNhanVien > 0 && (
        <Pagination
          disableAnimation
          radius="sm"
          showControls
          initialPage={searchParam.page}
          color="primary"
          total={Math.ceil(countNhanVien / 10)}
          onChange={onChangePage}
        />
      )}
    </FlexBox>
  );
}
