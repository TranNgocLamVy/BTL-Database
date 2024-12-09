import FlexBox from "@/components/Box/FlexBox";
import Container from "@/components/Container";
import { H1 } from "@/components/Heading";
import { ChiNhanh, NVTYPE, NhanVien } from "@/types";
import Search from "@/views/Search";
import StaffList from "@/views/NhanVienList";
import {
  countNhanVienWithParams,
  fetchChiNhanh,
  fetchNhanVien,
} from "@/libs/serverFetch";
import CustomPagnitation from "@/views/CustomPagnitation";
import AddNhanVienModal from "@/views/AddNhanVienModal";

interface Props {
  searchParams: SearchParams;
}

export default async function Home({ searchParams }: Props) {
  const param: SearchParams = {
    type: searchParams.type || NVTYPE.NhanVien,
    field: searchParams.field || "Ten",
    value: searchParams.value || "",
    page: searchParams.page || 1,
  };

  const NhanVienList: NhanVien[] = await fetchNhanVien(param);
  const ChiNhanhList: ChiNhanh[] = await fetchChiNhanh();
  const countWithParams = await countNhanVienWithParams(param);

  const label = () => {
    switch (param.type) {
      case NVTYPE.NhanVien:
        return "Nhân viên";
      case NVTYPE.GiangVien:
        return "Giảng viên";
      case NVTYPE.TroGiang:
        return "Trợ giảng";
      case NVTYPE.GiamSatVien:
        return "Giám sát viên";
      default:
        return "Nhân viên";
    }
  };

  return (
    <Container className="py-24 gap-4">
      <FlexBox className="w-10/12 justify-between">
        <FlexBox className="flex-col">
          <H1 className="text-4xl">Quản lý nhân viên</H1>
          <p className="text-xl font-medium">{`${countWithParams} ${label()}`}</p>
        </FlexBox>

        <AddNhanVienModal chiNhanhList={ChiNhanhList} />
      </FlexBox>
      <FlexBox className="w-10/12 justify-center">
        <Search param={param} />
      </FlexBox>
      <FlexBox className="w-10/12">
        <StaffList
          nhanVienList={NhanVienList}
          chiNhanhList={ChiNhanhList}
          param={param}
        />
      </FlexBox>
      <CustomPagnitation searchParam={param} countNhanVien={countWithParams} />
    </Container>
  );
}
