"use client";
import { useState } from "react";
import { Switch } from "@headlessui/react";
import { Character } from "../models";

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export function CharacterCard({ character }: { character: Character | null }) {
  const [enabled, setEnabled] = useState(false);
  if (!character) {
    return <></>;
  }
  return (
    <Switch checked={enabled} onChange={setEnabled}>
      <div
        className={classNames(
          enabled
            ? "bg-gray-100 border border-gray-50 shadow-sm"
            : "bg-white shadow-lg",
          "w-full flex flex-row p-6 hover:bg-gray-200 cursor-pointer text-gray-900 "
        )}
      >
        <div>
          <div className="p-2 h-32 w-32 flex justify-center items-center">
            <CharacterIcon />
          </div>
        </div>
        <div className="p-2 space-y-2 flex flex-col justify-between text-left">
          <div>
            <p className="text-black font-bold">{character.name}</p>
            <p className="text-black text-xs">{character.skills}</p>
          </div>
          <HealthMeter health={character.health} />
        </div>
      </div>
    </Switch>
  );
}

function HealthMeter({ health }: { health: number }) {
  const counter = Array.from({ length: 4 }, (_, index) => index + 1);
  return (
    <div className="flex flex-row justify-start items-center space-x-4">
      {counter.map(function (heart) {
        if (health >= heart) {
          return <FullHealthIcon key={heart} />;
        } else {
          return <EmptyHealthIcon key={heart} />;
        }
      })}
    </div>
  );
}

function FullHealthIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="#dc2626"
      className="w-6 h-6"
    >
      <path d="m11.645 20.91-.007-.003-.022-.012a15.247 15.247 0 0 1-.383-.218 25.18 25.18 0 0 1-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0 1 12 5.052 5.5 5.5 0 0 1 16.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 0 1-4.244 3.17 15.247 15.247 0 0 1-.383.219l-.022.012-.007.004-.003.001a.752.752 0 0 1-.704 0l-.003-.001Z" />
    </svg>
  );
}

function EmptyHealthIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth={1.5}
      stroke="currentColor"
      className="w-6 h-6 text-red-600"
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z"
      />
    </svg>
  );
}

function CharacterIcon() {
  return (
    <svg
      width="52px"
      height="80px"
      viewBox="0 0 52 80"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
    >
      <g
        id="Page-1"
        stroke="none"
        strokeWidth="1"
        fill="none"
        fillRule="evenodd"
      >
        <g id="noun-explorer-4903392" fill="#000000" fillRule="nonzero">
          <path
            d="M31.0942621,28.7957143 C31.0942621,28.0944444 31.6628335,27.525873 32.3641033,27.525873 C33.0653732,27.525873 33.6339446,28.0944444 33.6339446,28.7957143 C33.6339446,29.4969841 33.0653732,30.0655556 32.3641033,30.0655556 C31.6628335,30.0655556 31.0942621,29.4969841 31.0942621,28.7957143 Z M19.6656906,27.525873 C18.9644208,27.525873 18.3958494,28.0944444 18.3958494,28.7957143 C18.3958494,29.4969841 18.9644208,30.0655556 19.6656906,30.0655556 C20.3669605,30.0655556 20.9355319,29.4969841 20.9355319,28.7957143 C20.9355319,28.0944444 20.3671192,27.525873 19.6656906,27.525873 Z M28.0926748,32.3114286 C28.4301351,32.215873 28.6261668,31.8649206 28.5306113,31.5274603 C28.434897,31.1901587 28.0842621,30.9942857 27.7468017,31.0896825 C26.5953732,31.415873 25.4347383,31.415873 24.2833097,31.0896825 C23.9464843,30.9946032 23.5950557,31.1901587 23.4995002,31.5274603 C23.4039446,31.8647619 23.5999764,32.215873 23.9374367,32.3114286 C24.6255319,32.5063492 25.3245795,32.6052381 26.0152144,32.6052381 C26.7058494,32.6052381 27.4045795,32.5063492 28.0926748,32.3114286 Z M0.144579525,79.7684127 C0.023944604,79.621746 -0.0246268245,79.4288889 0.011881112,79.2425397 C3.07553191,63.6580952 11.0172779,56.4136508 17.2123573,53.0726984 C17.4720398,52.5853968 17.779024,52.0955556 18.1352144,51.6631746 C19.1712462,50.4052381 20.8380716,49.4326984 21.5696589,49.0425397 L21.5696589,47.6606349 C17.4196589,46.1450794 14.1485478,42.8447619 12.7721986,40.5507937 C12.4052144,39.9390476 12.0598176,39.1931746 11.7406113,38.3349206 C9.89124619,38.2977778 8.09489698,36.8950794 7.3375954,34.8209524 C6.42378587,32.3180952 7.27473825,29.6109524 9.23426206,28.5512698 C8.56188111,27.782381 8.1175954,26.8298413 7.92330968,25.7338095 C7.72378587,25.7801587 7.52981762,25.8257143 7.34727794,25.8695238 C5.86013508,26.2255556 4.36315095,25.3546032 3.94077,23.885873 C3.71981762,23.1179365 3.81823032,22.3280952 4.2139446,21.6493651 C4.60950016,20.9707937 5.24823032,20.4961905 6.0123573,20.3130159 C6.30553191,20.2426984 6.62696048,20.1673016 6.97410333,20.0880952 C7.09870651,14.9807937 9.08997635,9.94571429 12.4810875,6.20269841 C16.104897,2.20285714 20.9112462,0 26.014897,0 C31.1185478,0 35.9250557,2.20285714 39.5488652,6.20285714 C42.9402938,9.94619048 44.9315637,14.9814286 45.0558494,20.0890476 C45.4021986,20.1680952 45.7229922,20.2433333 46.0156906,20.3134921 C46.7796589,20.4966667 47.418389,20.9712698 47.8139446,21.6496825 C48.2096589,22.3284127 48.3079129,23.1180952 48.0909287,23.8734921 C48.0902938,23.8755556 48.0861668,23.8896825 48.0855319,23.891746 C47.7287065,25.1336508 46.5961668,25.9493651 45.3514049,25.9493651 C45.1298176,25.9493651 44.904897,25.9234921 44.6799764,25.8696825 C44.4972779,25.825873 44.303151,25.7803175 44.1034684,25.7338095 C43.9091827,26.8298413 43.464897,27.782381 42.792516,28.5512698 C44.7520398,29.6109524 45.6029922,32.3180952 44.6891827,34.8209524 C43.9318811,36.8949206 42.1353732,38.297619 40.2861668,38.3349206 C39.9669605,39.1931746 39.6215637,39.9390476 39.2545795,40.5507937 C37.8782303,42.8446032 34.6071192,46.1450794 30.4571192,47.6606349 L30.4571192,49.0425397 C31.1887065,49.4326984 32.8553732,50.4052381 33.8915637,51.6631746 C34.2475954,52.0955556 34.5545795,52.5853968 34.8142621,53.0726984 C41.0093414,56.4134921 48.9510875,63.6579365 52.0147383,79.2425397 C52.0512462,79.4287302 52.0026748,79.621746 51.8820398,79.7684127 C51.7614049,79.9150794 51.5818811,80 51.3918811,80 L0.634896985,80 C0.445055715,80 0.265214445,79.9150794 0.144579525,79.7684127 Z M50.0472779,76.3150794 L40.6244208,76.3150794 L40.6244208,78.7301587 L50.6147383,78.7301587 C50.4398176,77.8996825 50.2498176,77.095873 50.0472779,76.3150794 Z M49.2712462,73.6307937 L40.6244208,73.6307937 L40.6244208,75.0452381 L49.7004525,75.0452381 C49.5621986,74.5642857 49.4193414,74.092381 49.2712462,73.6307937 Z M30.4388652,50.4915873 C30.3444208,53.2653968 29.8828335,56.2142857 29.0587065,59.3206349 L29.0587065,61.9415873 L32.8815637,59.8609524 L31.0952144,57.3988889 C30.9737859,57.231746 30.9414049,57.0160317 31.0082303,56.8207937 C31.0750557,56.6253968 31.232516,56.4746032 31.4306113,56.4166667 L34.4850557,55.5226984 C34.2253732,54.7612698 33.6952144,53.4225397 32.9112462,52.4704762 C32.2310875,51.6446032 31.1841033,50.9350794 30.4388652,50.4915873 Z M29.1874367,49.4307937 L29.1874367,48.0568254 C28.1680716,48.3239683 27.1061668,48.4784127 26.0134684,48.4784127 C24.92077,48.4784127 23.8588652,48.3239683 22.8395002,48.0568254 L22.8395002,49.4307937 C22.8395002,53.9622222 23.909024,59.0528571 26.0152144,64.58 C28.1215637,59.0590476 29.1874367,53.9804762 29.1874367,49.4307937 Z M24.9442621,70.3001587 C24.4821986,71.2752381 24.2379129,72.3474603 24.2379129,73.4009524 L24.2379129,75.4814286 C24.2379129,75.8457143 24.5342621,76.1422222 24.8987065,76.1422222 L27.1280716,76.1422222 C27.492516,76.1422222 27.7888652,75.8457143 27.7888652,75.4814286 L27.7888652,63.4309524 C27.0096589,65.6519048 26.0610875,67.9431746 24.9442621,70.3001587 Z M42.1550557,29.6538095 C41.842516,32.4519048 41.35077,34.9698413 40.728389,37.018254 C41.8952144,36.7869841 42.9853732,35.7842857 43.4961668,34.3855556 C44.2001351,32.4580952 43.5961668,30.4022222 42.1550557,29.6538095 Z M42.8612462,25.4544444 C41.8437859,25.2326984 40.6802938,24.9971429 39.4052144,24.768254 C39.9047383,26.1574603 40.6318811,27.2369841 41.5764843,27.9888889 C42.2534684,27.3422222 42.6888652,26.4788889 42.8612462,25.4544444 Z M43.528389,17.3511111 C42.1982303,17.0425397 37.7321986,16.0557143 32.7206113,15.4890476 C32.4539446,16.408254 32.0045795,17.2506349 31.4123573,17.9719048 C36.2539446,18.3495238 40.6971192,19.1474603 43.7755319,19.8061905 C43.7429922,18.9750794 43.6596589,18.1555556 43.528389,17.3511111 Z M31.7277541,13.5468254 C31.7277541,10.395873 29.1644208,7.83253968 26.0134684,7.83253968 C22.862516,7.83253968 20.2991827,10.395873 20.2991827,13.5468254 C20.2991827,16.6977778 22.862516,19.2611111 26.0134684,19.2611111 C29.1644208,19.2611111 31.7277541,16.697619 31.7277541,13.5468254 Z M8.77299222,15.9865079 C10.5626748,15.5866667 14.5915637,14.7501587 19.0637859,14.2387302 C19.0412462,14.0109524 19.0293414,13.7803175 19.0293414,13.5466667 C19.0293414,9.69555556 22.1623573,6.56253968 26.0134684,6.56253968 C29.8645795,6.56253968 32.9975954,9.69555556 32.9975954,13.5466667 C32.9975954,13.7801587 32.9855319,14.0109524 32.963151,14.2387302 C37.438389,14.7504762 41.4691827,15.587619 43.2572779,15.9873016 C41.2980716,7.64968254 34.1960081,1.26984127 26.014897,1.26984127 C17.8341033,1.26984127 10.7321986,7.64936508 8.77299222,15.9865079 Z M8.25442079,19.8055556 C11.332516,19.1469841 15.7744208,18.3495238 20.6144208,17.9719048 C20.0220398,17.2504762 19.5728335,16.408254 19.3061668,15.4890476 C14.2963256,16.0555556 9.83584937,17.0407937 8.50172238,17.3503175 C8.37029381,18.1547619 8.28696048,18.9742857 8.25442079,19.8055556 Z M26.0134684,22.1969841 C33.6598176,22.1969841 41.1760081,23.7244444 44.9758494,24.6347619 C45.8020398,24.8325397 46.6326748,24.3495238 46.8669605,23.5346032 C46.8675954,23.532381 46.8717224,23.5184127 46.8723573,23.5161905 C46.9909287,23.1034921 46.9364843,22.6653968 46.7169605,22.2890476 C46.4975954,21.9126984 46.1434684,21.6496825 45.7196589,21.5480952 C42.7156906,20.8279365 36.7291827,19.5684127 30.1671192,19.1573016 C29.0053732,20.0196825 27.5680716,20.5306349 26.0134684,20.5306349 C24.4588652,20.5306349 23.0215637,20.0195238 21.8598176,19.1573016 C15.298389,19.568254 9.3123573,20.827619 6.30854778,21.5477778 C5.88457952,21.6493651 5.53045254,21.9125397 5.31108746,22.2888889 C5.09172238,22.6652381 5.03711921,23.1033333 5.1575954,23.522381 C5.39537318,24.3493651 6.22569064,24.8326984 7.05172238,24.6344444 C10.8512462,23.7242857 18.3674367,22.1969841 26.0134684,22.1969841 Z M10.4504525,27.9887302 C11.3952144,27.2368254 12.1221986,26.1573016 12.6217224,24.7680952 C11.346643,24.9971429 10.183151,25.2326984 9.16569064,25.4542857 C9.33791286,26.4788889 9.77330968,27.3422222 10.4504525,27.9887302 Z M11.2985478,37.0187302 C10.6760081,34.9701587 10.1842621,32.4520635 9.87172238,29.6538095 C8.43061127,30.4020635 7.82664302,32.4580952 8.53061127,34.3855556 C9.04140492,35.7844444 10.1315637,36.7879365 11.2985478,37.0187302 Z M26.0134684,47.2084127 C31.6710875,47.2084127 36.4699764,42.724127 38.1660081,39.897619 C39.4188652,37.8093651 40.4480716,33.7909524 40.9379129,29.0992063 C39.5747383,28.0765079 38.5853732,26.5407937 37.99077,24.5249206 C34.4582303,23.9461905 30.2536271,23.4669841 26.0134684,23.4669841 C21.7733097,23.4669841 17.5687065,23.9461905 14.0361668,24.5249206 C13.4415637,26.5406349 12.4521986,28.0765079 11.089024,29.0992063 C11.5788652,33.7909524 12.6080716,37.8093651 13.8609287,39.897619 C15.5569605,42.724127 20.3558494,47.2084127 26.0134684,47.2084127 Z M17.5417224,55.5226984 L20.5961668,56.4166667 C20.7942621,56.4746032 20.9517224,56.6253968 21.0185478,56.8207937 C21.0853732,57.0160317 21.0529922,57.231746 20.9315637,57.3988889 L19.1452144,59.8609524 L23.9068017,62.4526984 C22.4915637,58.1784127 21.7142621,54.1720635 21.5879129,50.4915873 C20.8429922,50.9349206 19.7956906,51.6446032 19.1155319,52.4706349 C18.3314049,53.4225397 17.8012462,54.7611111 17.5417224,55.5226984 Z M3.18346841,72.3609524 L11.4023573,72.3609524 L11.4021986,64.507619 C11.4021986,64.1569841 11.6864843,63.8726984 12.0371192,63.8726984 C12.3877541,63.8726984 12.6720398,64.1569841 12.6720398,64.507619 L12.6723573,78.7301587 L39.3545795,78.7301587 L39.3547383,64.507619 C39.3547383,64.1569841 39.639024,63.8726984 39.9896589,63.8726984 C40.3402938,63.8726984 40.6245795,64.1569841 40.6245795,64.507619 L40.6244208,72.3609524 L48.8433097,72.3609524 C45.5591827,63.072381 40.2799764,57.8988889 35.6596589,55.0293651 C35.8095002,55.461746 35.888389,55.7534921 35.8974367,55.7874603 C35.9858494,56.1203175 35.7926748,56.4631746 35.4621986,56.5598413 L32.6521986,57.3822222 L34.3339446,59.7001587 C34.4412462,59.8480952 34.4796589,60.0349206 34.4393414,60.2130159 C34.399024,60.3911111 34.2839446,60.5433333 34.1236271,60.6306349 L29.059024,63.3873016 L29.059024,75.4812698 C29.059024,76.545873 28.1929922,77.4119048 27.128389,77.4119048 L24.899024,77.4119048 C23.8344208,77.4119048 22.968389,76.5457143 22.968389,75.4812698 L22.968389,73.4007937 C22.968389,72.1604762 23.2550557,70.9001587 23.7972779,69.7561905 C24.3501351,68.5893651 24.86077,67.4395238 25.3291827,66.3073016 C25.0475954,65.6111111 24.7796589,64.9207937 24.5295002,64.2371429 L17.9037859,60.6306349 C17.7433097,60.5433333 17.628389,60.3911111 17.5880716,60.2130159 C17.5477541,60.0349206 17.5861668,59.8480952 17.6934684,59.7001587 L19.3752144,57.3822222 L16.5652144,56.5598413 C16.2347383,56.4631746 16.0415637,56.1203175 16.1299764,55.7874603 C16.139024,55.7534921 16.2179129,55.4619048 16.3677541,55.0295238 C11.7468017,57.8988889 6.4675954,63.0725397 3.18346841,72.3609524 Z M2.32648429,75.0452381 L11.402516,75.0452381 L11.402516,73.6307937 L2.75569064,73.6307937 C2.60743667,74.092381 2.46457952,74.5642857 2.32648429,75.0452381 Z M1.41203984,78.7301587 L11.4023573,78.7301587 L11.4023573,76.3150794 L1.97950016,76.3150794 C1.77711921,77.095873 1.58711921,77.8996825 1.41203984,78.7301587 Z M29.9310875,13.5468254 C29.9310875,15.7071429 28.1736271,17.4646032 26.0133097,17.4646032 C23.8529922,17.4646032 22.0955319,15.7071429 22.0955319,13.5468254 C22.0955319,11.3866667 23.8529922,9.62904762 26.0133097,9.62904762 C28.1736271,9.62904762 29.9310875,11.3865079 29.9310875,13.5468254 Z M28.6612462,13.5468254 C28.6612462,12.0868254 27.4734684,10.8988889 26.0133097,10.8988889 C24.553151,10.8988889 23.3653732,12.0866667 23.3653732,13.5468254 C23.3653732,15.0069841 24.553151,16.1947619 26.0133097,16.1947619 C27.4734684,16.1947619 28.6612462,15.0068254 28.6612462,13.5468254 Z"
            id="Shape"
          ></path>
        </g>
      </g>
    </svg>
  );
}
