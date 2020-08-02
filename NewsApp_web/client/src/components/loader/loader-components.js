import BounceLoader from "react-spinners/BounceLoader";
import React from 'react';
import { css } from "@emotion/core";
import "./loader-styles.css";

const override = css`
  margin: auto auto;
`;

export const Loading = props => (
    <div className="loading_container">
        <BounceLoader
        css={override}
        size={45}
        color={"#3D60D2"}
        loading={props.loading}
        />
        <h4>Loading</h4>
    </div>
);


