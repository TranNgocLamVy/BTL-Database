"use client";
import FlexBox from "@/components/Box/FlexBox";
import Container from "@/components/Container";
import { test } from "@/libs/serverAction";
import { Button } from "@nextui-org/react";

export default function Home() {
  const testfn = async () => {
    const res = await test();
    console.table(res);
  };

  return (
    <Container className="py-24 gap-10">
      <FlexBox className="items-center justify-center">
        <Button onClick={testfn}>Test</Button>
      </FlexBox>
    </Container>
  );
}
