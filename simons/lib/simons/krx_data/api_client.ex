defmodule Simons.KrxData.ApiClient do
  @doc """
  POST /comm/bldAttendant/getJsonData.cmd HTTP/1.1
  Host: data.krx.co.kr
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:141.0) Gecko/20100101 Firefox/141.0
  Accept: application/json, text/javascript, */*; q=0.01
  Accept-Language: en-US,en;q=0.5
  Accept-Encoding: gzip, deflate
  Content-Type: application/x-www-form-urlencoded; charset=UTF-8
  X-Requested-With: XMLHttpRequest
  Content-Length: 281
  Origin: http://data.krx.co.kr
  Connection: keep-alive
  Referer: http://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201020201
  Cookie: __smVisitorID=sAiIprWXh2k; JSESSIONID=Qtq2GBK8HxoYz5aFCLa6OaPEP2C9YcKvs6QW4osGL8JUwmlJl7gV7OrBEYJhn58s.bWRjX2RvbWFpbi9tZGNvd2FwMi1tZGNhcHAwMQ==

  {
    "bld": "dbms/MDC/STAT/standard/MDCSTAT02103",
    "locale": "ko_KR",
    "tboxisuCd_finder_stkisu0_1": "001440/대한전선",
    "isuCd": "KR7001440007",
    "isuCd2": "KR7005930003",
    "codeNmisuCd_finder_stkisu0_1": "대한전선",
    "param1isuCd_finder_stkisu0_1": "ALL",
    "csvxls_isNo": "false"
  }
  """
  def get_profile(isin) do
    new()
    |> Req.post!(
      form: %{
        bld: "dbms/MDC/STAT/standard/MDCSTAT02103",
        isuCd: isin,
        isuCd2: isin
      }
    )
  end

  @doc """
  POST /comm/bldAttendant/getJsonData.cmd HTTP/1.1
  Host: data.krx.co.kr
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:141.0) Gecko/20100101 Firefox/141.0
  Accept: application/json, text/javascript, */*; q=0.01
  Accept-Language: en-US,en;q=0.5
  Accept-Encoding: gzip, deflate
  Content-Type: application/x-www-form-urlencoded; charset=UTF-8
  X-Requested-With: XMLHttpRequest
  Content-Length: 358
  Origin: http://data.krx.co.kr
  Connection: keep-alive
  Referer: http://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201020201
  Cookie: __smVisitorID=sAiIprWXh2k; JSESSIONID=Qtq2GBK8HxoYz5aFCLa6OaPEP2C9YcKvs6QW4osGL8JUwmlJl7gV7OrBEYJhn58s.bWRjX2RvbWFpbi9tZGNvd2FwMi1tZGNhcHAwMQ==

  {
    "bld": "dbms/MDC/STAT/standard/MDCSTAT01701",
    "locale": "ko_KR",
    "tboxisuCd_finder_stkisu0_4": "001440/대한전선",
    "isuCd": "KR7001440007",
    "isuCd2": "KR7005930003",
    "codeNmisuCd_finder_stkisu0_4": "대한전선",
    "param1isuCd_finder_stkisu0_4": "ALL",
    "strtDd": "20250731",
    "endDd": "20250808",
    # 수정주가 적용
    "adjStkPrc_check": "Y",
    "adjStkPrc": "2",
    # 주, 천주, 백만주
    "share": "1",
    # 원, 천원, 백만원, 십억원
    "money": "1",
    "csvxls_isNo": "false"
  }
  """
  def get_candles(isin, s_date, e_date) do
    new()
    |> Req.post!(
      form: %{
        bld: "dbms/MDC/STAT/standard/MDCSTAT01701",
        isuCd: isin,
        isuCd2: isin,
        strtDd: Calendar.strftime(s_date, "%Y%m%d"),
        endDd: Calendar.strftime(e_date, "%Y%m%d"),
        adjStkPrc: "1",
        share: "1",
        money: "1"
      }
    )
  end

  @doc """
  POST /comm/bldAttendant/getJsonData.cmd HTTP/2
  Host: data.krx.co.kr
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:141.0) Gecko/20100101 Firefox/141.0
  Accept: application/json, text/javascript, */*; q=0.01
  Accept-Language: en-US,en;q=0.5
  Accept-Encoding: gzip, deflate, br, zstd
  Content-Type: application/x-www-form-urlencoded; charset=UTF-8
  X-Requested-With: XMLHttpRequest
  Content-Length: 283
  Origin: https://data.krx.co.kr
  Connection: keep-alive
  Referer: https://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201010102
  Cookie: __smVisitorID=sAiIprWXh2k; JSESSIONID=ZxzyYA7ullhNP04aQVkqVjaTKzNI1n6uyZHJa9h8UNdAugYrlp01TdR7OpyzDBQ0.bWRjX2RvbWFpbi9tZGNvd2FwMi1tZGNhcHAwMQ==
  Sec-Fetch-Dest: empty
  Sec-Fetch-Mode: cors
  Sec-Fetch-Site: same-origin
  Priority: u=0
  TE: trailers

  {
    "bld": "dbms/MDC/STAT/standard/MDCSTAT00301",
    "locale": "ko_KR",
    "tboxindIdx_finder_equidx0_2": "코스피",
    "indIdx": "1",
    "indIdx2": "001",
    "codeNmindIdx_finder_equidx0_2": "코스피",
    "param1indIdx_finder_equidx0_2": "",
    "strtDd": "20230101",
    "endDd": "20241231",
    "share": "1",
    "money": "1",
    "csvxls_isNo": "false"
  }
  """
  def get_kospi_candles(s_date, e_date) do
    new()
    |> Req.post!(
      form: %{
        bld: "dbms/MDC/STAT/standard/MDCSTAT00301",
        tboxindIdx_finder_equidx0_2: "코스피",
        indIdx: "1",
        indIdx2: "001",
        codeNmindIdx_finder_equidx0_2: "코스피",
        strtDd: Calendar.strftime(s_date, "%Y%m%d"),
        endDd: Calendar.strftime(e_date, "%Y%m%d"),
        share: "1",
        money: "1"
      }
    )
  end

  defp new() do
    Req.new(
      base_url: "http://data.krx.co.kr",
      url: "comm/bldAttendant/getJsonData.cmd",
      headers: [Referer: "http://data.krx.co.kr"]
    )
    |> Req.Request.prepend_response_steps(
      put_content_type: fn {request, response} ->
        {request, Req.Response.put_header(response, "content-type", "application/json")}
      end
    )
  end
end
