import React from 'react';
import { FaBookmark } from "react-icons/fa";
import './bookmark-display-styles.css';
import ReactTooltip from "react-tooltip";


export const FilledBookmark = () => (
    <>
    <FaBookmark className="bookmark_icon_display" data-tip data-for='bk'/>
    <ReactTooltip id="bk" place="bottom">
        Bookmark 
    </ReactTooltip>
    </>
);