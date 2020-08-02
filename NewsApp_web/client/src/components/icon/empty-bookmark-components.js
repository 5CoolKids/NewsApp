import React from 'react';
import { FaRegBookmark } from "react-icons/fa";
import './bookmark-display-styles.css';
import ReactTooltip from "react-tooltip";


export const EmptyBookmark = props => (
    <>
    <FaRegBookmark className="bookmark_icon_display" onClick={props.onClick} data-tip data-for='bk'/>
    <ReactTooltip id="bk" place="bottom">
        Bookmark 
    </ReactTooltip>
    </>
);
