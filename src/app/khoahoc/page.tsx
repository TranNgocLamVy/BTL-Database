import FlexBox from "@/components/Box/FlexBox";
import Container from "@/components/Container";
import { H1 } from "@/components/Heading";
import { KhoaHoc } from "@/types";
import { fetchKhoaHoc } from "@/libs/serverFetch";
import KhoaHocList from "@/views/KhoaHocList";

interface Props {
  searchParams: SearchParams;
}

const getDate = () => {
  const date = new Date().toLocaleDateString().split("/");
  return `${date[2]}-${date[0]}-${date[1]}`;
};

export default async function Home({ searchParams }: Props) {
  const param: SearchParams = {
    value: searchParams.value || getDate(),
  };

  const khoaHocList: KhoaHoc[] = await fetchKhoaHoc(param.value ?? getDate());

  return (
    <Container className="py-24 gap-4">
      <FlexBox className="w-9/12 justify-between">
        <FlexBox className="flex-col">
          <H1 className="text-4xl">Khóa học có thể đăng kí</H1>
        </FlexBox>
      </FlexBox>
      <FlexBox className="w-9/12">
        <KhoaHocList khoaHocList={khoaHocList} param={param} />
      </FlexBox>
    </Container>
  );
}
