import React from 'react';
import { FaRegBookmark } from "react-icons/fa";
import './bookmark-display-styles.css';
import './bookmark-save-styles.css';
import ReactTooltip from "react-tooltip";


export const NoSavedBookmark = (props) => (
    <>
    <FaRegBookmark size={"1.5em"} className="bookmark_icon_save" onClick={props.onClick} data-tip data-for='detail_bk'/>
    <ReactTooltip id="detail_bk" place="top" >
        Bookmark 
    </ReactTooltip>
    </>
);